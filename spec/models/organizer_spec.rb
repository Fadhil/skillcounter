require 'rails_helper'

RSpec.describe Organizer, :type => :model do
  
  describe "Organizer attributes" do
        subject { Organizer.new }
        it { is_expected.to respond_to :name }
        it { is_expected.to respond_to :contact_number }
        it { is_expected.to respond_to :email }
        it { is_expected.to respond_to :address }
        it { is_expected.to respond_to :organizerID }
    end
    
    describe "invalid name" do
        subject(:invalid_name) { build(:organizer, name: "a"*51)  }
        it "should not excced 50 characters" do
            expect(invalid_name).to_not be_valid
        end
    end
    
    describe "invalid contact_number" do 
        subject(:invalid_contact_number) { build(:organizer, contact_number: "abd-12345678") }
        it "should be in contact number format" do
            expect(invalid_contact_number).to_not be_valid
        end
    end
    
    describe "invalid email" do 
        if 
            subject(:invalid_email) { build(:organizer, email: "magicmagic.com") }
            it "should be in email format" do
                expect(invalid_email).to_not be_valid
            end
        
        else
            let(:organizer1) { create(:organizer, email: "organizer1@email.com") }
            let(:invalid_organizer) { build(:organizer, email: "organizer1@email.com") }
            subject{ invalid_email }
            it "should be a unique Organizer email" do
                expect(invalid_email).to_not be_valid
            end
        end
        
    end
    
    describe "invalid address" do 
        subject(:invalid_address) { build(:organizer, address: "a" * 256) }
        it "Address length is out of the range" do
            expect(invalid_address).to_not be_valid
        end
    end
    
     describe "invalid Organizer ID" do 
        if 
            subject(:invalid_organizer) { build(:organizer, organizerID: "magicmagic.com") }
            it "should be in Organizer ID format" do
                expect(invalid_organizer).to_not be_valid
            end
        else
            let(:organizer1) { create(:organizer, organizerID: 123456) }
            let(:invalid_organizer) { build(:organizer, organizerID: 123456) }
            subject{ invalid_organizer }
            it "should be a unique Organizer ID" do
                expect(invalid_organizer).to_not be_valid
            end
        end
    end
    
    
  
  
end
