require 'rails_helper'

RSpec.describe Event, :type => :model do
  
  describe "Event attributes" do
        subject { Event.new }
        it { is_expected.to respond_to :event_id }
        it { is_expected.to respond_to :event_name }
        it { is_expected.to respond_to :desciption }
        it { is_expected.to respond_to :location }
        # it { is_expected.to respond_to :start_date_time }
        # it { is_expected.to respond_to :end_date_time }
        # it { is_expected.to respond_to :venue_capacity }
        # it { is_expected.to respond_to :ticket_quantity }
        # it { is_expected.to respond_to :event_page_url }
        # it { is_expected.to respond_to :status }
    end
    
    describe "invalid desciption" do
        subject(:invalid_description) { build(:event, desciption: "a"*2501)  }
        it "should not excced 2500 characters" do
            expect(invalid_description).to_not be_valid
        end
    end
    
    describe "invalid location" do
        subject(:invalid_location) { build(:event, location: "a"*256)  }
        it "address length is out of the range" do
            expect(invalid_location).to_not be_valid
        end
    end
    
    # describe "invalid format" do
    #     subject(:invalid_format) { build(:event, start_date_time: "")  }
    #     it "the format is incorrect" do
    #         expect(invalid_format).to_not be_valid
    #     end
    # end
    
    # describe "invalid venue" do
    #   if
    #     subject(:invalid_venue) { build(:event, venue_capacity: -1)  }
    #     it "should not give a negative value" do
    #       expect(invalid_venue).to_not be_valid
    #     end
    #   else
    #     subject(:invalid_venue) { build(:event, venue_capacity: "one hundred")  }
    #     it "should give a numerical value" do
    #       expect(invalid_venue).to_not be_valid
    #     end
    #   end
    # end
    
    # describe "invalid ticket" do
    #   if
    #     subject(:invalid_ticket) { build(:event, ticket_quantity: -1)  }
    #     it "should not give a negative value" do
    #       expect(invalid_ticket).to_not be_valid
    #     end
    #   else
    #     subject(:invalid_ticket) { build(:event, ticket_quantity: "three")  }
    #     it "should give a numerical value" do
    #       expect(invalid_ticket).to_not be_valid
    #     end
    # end
end
