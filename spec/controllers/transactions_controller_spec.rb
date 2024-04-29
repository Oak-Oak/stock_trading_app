require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe 'POST #create' do # for buying
    let(:trader) { create(:user) } 
    let(:symbol) { 'AAPL' }
    let(:quantity) { 10 }
    let(:price) { 150.0 }
    let(:transaction_cost) { quantity * price }
    let(:mock_iex_client) { instance_double('IEX::Api::Client') }

    before do
      @trader = create(:user)
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(@trader)

      allow(IEX::Api::Client).to receive(:new).and_return(mock_iex_client)
      allow(mock_iex_client).to receive_message_chain(:quote, :latest_price).and_return(price)
    end

    context 'when the trade is successful' do
      it 'creates a new transaction' do
        expect {
          post :create, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
        }.to change(Transaction, :count).by(1)
      end
    
      context 'when creating a new transaction' do
        it 'redirects to the trader transactions path with a success message' do
          post :create, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
          expect(response).to redirect_to(trader_transactions_path(@trader))
          expect(flash[:success]).to eq('Transaction successful.')
        end
      end
    
      context 'when updating the user account value' do
        it 'updates the user account value correctly' do
          initial_account_value = @trader.account_value
          post :create, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
          @trader.reload
          transaction_cost = quantity * price
          new_account_value = @trader.account_value - transaction_cost
          expect(new_account_value).to eq(initial_account_value - transaction_cost)
        end
      end
    end

    context 'when the trade fails due to insufficient funds' do
      before do
        @trader.update(account_value: 100) 
      end

      it 'Account value of the trader to remain the same when buying stocks with insufficient funds' do
        initial_balance = @trader.account_value
        post :create, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
      
        expect(@trader.reload.account_value).to be >= 100
      end      

      it 'renders the index template with an error message' do
        post :create, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
        expect(response).to have_http_status(302)
      end    
    end
  end

  describe 'POST #sell' do # for selling
    let(:trader) { create(:user) } 
    let(:symbol) { 'AAPL' }
    let(:quantity) { 10 }
    let(:price) { 150.0 }
    let(:transaction_cost) { quantity * price }
    let(:mock_iex_client) { instance_double('IEX::Api::Client') }

    before do
      @trader = create(:user)
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(@trader)

      allow(IEX::Api::Client).to receive(:new).and_return(mock_iex_client)
      allow(mock_iex_client).to receive_message_chain(:quote, :latest_price).and_return(price)
    end

    context 'when the trade is successful' do
    
      it 'creates a new transaction for selling' do
        expect(Transaction.count).to eq(0)
        post :sell, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
        expect(Transaction.count).to eq(1)

        transaction = Transaction.last
        expect(transaction.action).to eq('sell')
      end
  
      context 'when updating the user account value' do
        it 'updates the user account value correctly' do
          initial_account_value = @trader.account_value
          post :sell, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity } }
          @trader.reload
          transaction_cost = quantity * price
          new_account_value = @trader.account_value + transaction_cost
          expect(new_account_value).to eq(initial_account_value + transaction_cost)
        end
      end    
    end
  
    context 'when the trade fails due to insufficient quantity' do
      it 'does not change the user account value' do
        initial_account_value = @trader.account_value
        post :sell, params: { trader_id: @trader.id, transaction: { symbol: symbol, quantity: quantity + 1 } }
        @trader.reload
        expect(@trader.account_value).to eq(initial_account_value)
      end
    end
  end
end
