require 'rails_helper'

RSpec.describe User, type: :model do
  
    context "On User create" do
    
      it "should validate factory user" do
        @user = build(:user)
        expect(@user).to be_valid
      end
  
      it "should not validate users without a password" do
        @user = build(:user, password:"" )
        expect(@user).to_not be_valid
      end
  
 
      it "should not validate users without an email address" do
        @user = build(:user, email: "not_valid_email" )
        expect(@user).to_not be_valid
      end
  
    end
  
  
   context "portfolio image" do
       
      
  it { should have_attached_file(:avatar) }
  it { should_not validate_attachment_presence(:avatar) }
  it { should validate_attachment_content_type(:avatar).
                allowing('image/png', 'image/gif').
                rejecting('text/plain', 'text/xml') }
  it { should validate_attachment_size(:avatar).
                less_than(1.megabytes) }

end
  
  

  
  
  describe "Follow and unFollow Methods" do
    before do
      @user = create(:user)
      @user1 = create(:user)
    end
    
    it 'will be false' do
      expect(@user.following?(@user1)).to be false
    end
    

    
    it 'will follow then unfollow a user' do
      @user.follow(@user1)
      expect(@user.following?(@user1)).to be true
      
      expect(@user1.being_followed?(@user)). to be true
      
      @user.unfollow(@user1)
      expect(@user.following?(@user1)).to be false
    end
    
    
  end
      
  
  
  
end
