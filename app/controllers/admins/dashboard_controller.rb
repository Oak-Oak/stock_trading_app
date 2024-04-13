class Admins::DashboardController < ApplicationController
    def index
        @traders = User.where(role: 'trader')
    end
end
