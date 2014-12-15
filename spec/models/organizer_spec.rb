require 'rails_helper'
RSpec.describe Organizer do

    describe "fully valid organizer" do
       subject { build(:Organizer) }
       it { is_expected.to be_valid }
    end
    
    describe "organizer attributes" do
        subject { Organizer.new }
        it { is_expected.to respond_to :email }
        it { is_expected.to respond_to :contact_number }
        it { is_expected.to respond_to :address }
    end    
end
