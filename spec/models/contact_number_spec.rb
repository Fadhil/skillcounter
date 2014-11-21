require 'rails_helper'

RSpec.describe ContactNumber, :type => :model do
    
    describe "invalid relationship" do
        
        let(:relationship) { create(:organizer, contact_number: "0122122121", organizerID: 123) }
        let(:invalid_relationship) { build(:organizer, contact_number: "0122122121", organizerID: 223) }
        subject{ invalid_relationship }
        it "should has one organizer only" do
            expect(invalid_relationship).to_not be_valid
        end
    end
end
