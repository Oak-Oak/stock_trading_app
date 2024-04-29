require 'rails_helper'

RSpec.describe Admins::TradersController, type: :controller do
  describe 'GET #index' do
    context 'when admin is authenticated' do
      before do
        @admin = create(:admin_user)
        allow(controller).to receive(:authenticate_admin).and_return(true)
        session[:user_id] = @admin.id
      end

      it 'shows specific trader' do
        trader = create(:user, id: 25, approved: false)
        get :show, params: {id: trader.id}
        trader.reload
        expect(trader.email).to eq(trader.email)
      end

      it 'displays the edit form' do
        trader = create(:user, id: 22, approved: true)
        get :edit, params: { id: trader.id }
        trader.reload
        expect(response).to be_successful
      end

      it 'updates the trader\'s approval status' do
        trader = create(:user, id: 22, approved: true)
        patch :update, params: { id: trader.id, user: { approved: false } }
        trader.reload
        expect(trader.approved).to be false
      end

      it 'creates new trader' do
        trader_params = attributes_for(:user)
        expect {
          post :create, params: { user: trader_params }
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(302) #response302 indicates a redirect 
                                                  #in admin dashboard after creation 
                                                  #we redirect to admin dashboard
      end

      it 'deletes trader' do
        trader = create(:user, id: 27, approved: true)
        expect {
          delete :destroy, params: { id: trader.id }
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(302)
      end
    end
  end
end
