require 'rails_helper'
RSpec.describe User do
    
    describe "fully valid user" do
       subject { build(:user) }
       it { is_expected.to be_valid }
    end
    
    describe "user attributes" do
        subject { User.new }
        it { is_expected.to respond_to :name }
        it { is_expected.to respond_to :licence_number }
        it { is_expected.to respond_to :ic_number }
        it { is_expected.to respond_to :contact_number }
        it { is_expected.to respond_to :current_points }
        it { is_expected.to respond_to :expiring_points }
    end
    
    describe "invalid name" do
        subject(:invalid_name) { build(:user, name: "a"*51)  }
        it "should not excced 50 characters" do
            expect(invalid_name).to_not be_valid
        end
    end
    
    describe "invalid ic_number" do
        subject(:invalid_ic_number) { build(:user, ic_number: "abcs123-33-as-3") }
        it "should be in ic format" do
            expect(invalid_ic_number).to_not be_valid
        end
    end
    
    describe "invalid contact_number" do 
        subject(:invalid_contact_number) { build(:user, contact_number: "abd-12345678") }
        it "should be in contact number format" do
            expect(invalid_contact_number).to_not be_valid
        end
    end
    
    describe "invalid current points" do
        subject(:invalid_current_points_negative) { build(:user, current_points: -123) }
        subject(:invalid_current_points_char) { build(:user, current_points: "asd") }
        it "should not be a negative value" do
            expect(invalid_current_points_negative).to_not be_valid
        end
        
        it "should not have characters" do
            expect(invalid_current_points_char).to_not be_valid
        end
    end
    
    describe "invalid expiring points" do
        subject(:invalid_expiring_points_negative) { build(:user, expiring_points: -123) }
        subject(:invalid_expiring_points_char) { build(:user, expiring_points: "asd") }
        it "should not be a negative value" do
            expect(invalid_expiring_points_negative).to_not be_valid
        end
        
        it "should not have characters" do
            expect(invalid_expiring_points_char).to_not be_valid
        end
    end
end