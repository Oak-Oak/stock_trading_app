require 'rails_helper'

RSpec.describe Traders::DashboardController, type: :controller do
  describe 'GET #index' do
    context 'when trader is authenticated' do
      before do
        @trader = create(:user)
        allow(controller).to receive(:current_user).and_return(@trader) 
      end

      it 'retrieves index of stocks database' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
