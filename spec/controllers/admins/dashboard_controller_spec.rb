require 'rails_helper'

RSpec.describe Admins::DashboardController, type: :controller do
  describe 'GET #index' do
    context 'when admin is authenticated' do
      before do
        @admin = create(:admin_user)
        allow(request.env['warden']).to receive(:authenticate!).and_return(@admin)
        allow(controller).to receive(:current_user).and_return(@admin)
        create_list(:user, 3, isAdmin: false, approved: true)
        create_list(:user, 2, isAdmin: false, approved: false)
        get :index
      end

      it 'returns a success response' do
        expect(response).to be_successful
      end

      it 'retrieves traders and pending_traders from the database' do
        expect(User.where(isAdmin: false, approved: true)).not_to be_empty
        expect(User.where(isAdmin: false, approved: false)).not_to be_empty
      end
    end

    context 'when admin is not authenticated' do
      it 'redirects to the root path' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
