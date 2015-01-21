class Vet < User
    before_create :initialize_points
    has_attached_file :avatar, :styles => {:thumb => "100x100"}
    
    validates :licence_number, presence: true, uniqueness: true
    validates :ic_number, presence: true, format: { with: /\A\d{6}\-\d{2}\-\d{4}\z/ }
    validates :contact_number, presence: true, format: { with: /\A[0][1]\d{1}\-\d{7,8}\z/ }
    validates :current_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :expiring_points, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
     
     
    def self.search(search)
        if search
        find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
        else
        find(:all)
        end
    end


    # Set points to 0 upon build
    def initialize_points
        self.current_points = 0
        self.expiring_points = 0
    end


    # Sets a temporary password and saves the vet
    def claim
        if encrypted_password.blank? # Vet hasn't been claimed before
            if generated_password = generate_password 
                Rails.logger.info 'generating' + generated_password
                self.password                = generated_password
                self.password_confirmation   = generated_password
                Rails.logger.info "The password: #{self.password}"
            end
            if save
                true
            else
                false
            end
        end
    end


    def generate_password
        email[0..2] + ic_number[0..2] + licence_number[0..2] if !email.blank? && !ic_number.blank? && !licence_number.blank?
    end


    # def redeem_licence
    #    @vet = Vet.find(params[:id])
    #     points = @vet.current_points
    #     if points > 80
    #        flash[:success] = "You had redeem your licence"
    #     else
    #       flash[:error] = "Not enough points, you can get points by sign up more events"
    #     end
    #     #redirect_to vet_path(current_user)
    #     redirect_to :back
    # end

end
