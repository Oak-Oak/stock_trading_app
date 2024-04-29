require 'rails_helper'

RSpec.describe Admins::DashboardController, type: :controller do
  describe 'GET #index' do
    context 'when admin is authenticated' do
      before do
        @admin = create(:admin_user)
        allow(controller).to receive(:authenticate_admin).and_return(true)
        session[:user_id] = @admin.id
        create_list(:user, 3, isAdmin: false, approved: true)
        create_list(:user, 2, isAdmin: false, approved: false)
        get :index
      end

      it 'retrieves traders and pending_traders from the database' do
        expect(User.where(isAdmin: false, approved: true)).not_to be_empty
        expect(User.where(isAdmin: false, approved: false)).not_to be_empty
      end
    end
  end

  describe 'PATCH #approve_trader' do
    context 'when admin is authenticated' do
      before do
        @admin = create(:admin_user)
        allow(controller).to receive(:authenticate_admin).and_return(true)
        session[:user_id] = @admin.id
        get :index
      end

      it 'approves pending_traders from the database' do
        trader = create(:user, id: 25, approved: false)
        patch :approve_trader, params: {id: trader.id}
        trader.reload
        expect(trader.approved).to be true
      end

      it 'rejects pending_traders from the database and removes them' do
        trader = create(:user, id: 2, approved: false)
        expect {
                patch :reject_trader, params: { id: trader.id }
               }.to change(User, :count).by(-1)
        expect { trader.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
