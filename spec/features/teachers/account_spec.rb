require "rails_helper"

describe "As a logged-in teacher" do
  describe "when I visit my account page" do
    before :each do
      @teacher = create(:teacher, password: "password")
    end

    it "shows me my information" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@teacher)
      visit account_path
      within ".dynamic-container" do
        expect(page).to have_content("First Name: #{@teacher.first_name}")
        expect(page).to have_content("Last Name: #{@teacher.last_name}")
        expect(page).to have_content("Email: #{@teacher.email}")
        expect(page).to have_content("Password: ••••••••")
      end
    end

    it "allows me to update my non-password information" do
      old_name = @teacher.last_name
      old_email = @teacher.email
      visit welcome_path
      fill_in 'session[email]', with: @teacher.email
      fill_in 'session[password]', with: "password"
      click_on "LOG IN"
      visit account_path
      click_link "EDIT INFORMATION"

      expect(page).to_not have_content("password")
      fill_in "teacher[last_name]", with: "Nitro"
      fill_in "teacher[email]", with: "wnitro@example.com"
      click_on "SUBMIT CHANGES"

      expect(current_path).to eq(account_path)
      expect(page).to have_content("Successfully Updated Account Information")
      expect(page).to have_content("#{@teacher.first_name} Nitro")
      expect(page).to_not have_content("#{@teacher.first_name} #{old_name}")
      expect(page).to have_content("wnitro@example.com")
      expect(page).to_not have_content(old_email)
    end

    xit "allows me to update my password" do
      old_password = @teacher.password

      click_link "RESET PASSWORD"

      fill_in "teacher[Old Password]", with: old_password
      fill_in "teacher[New Password]", with: "new_password"
      fill_in "teacher[Confirm New Password]", with: "new_password"
      click_on "SUBMIT CHANGES"

      expect(page).to have_content("Successfully Reset Password")

      click_link "Log Out"

      fill_in "session[email]", with: @teacher.email
      fill_in "session[password]", with: @teacher.password
      click_on "Log In"

      expect(page).to have_content("Logged in as #{@teacher.first_name} #{@teacher.last_name}")
    end

    xit "allows me to cancel an account update" do
      click_link "Edit Information"
      click_link "Cancel"

      expect(current_path).to eq(account_path)

      click_link "Reset Password"
      click_link "Cancel"

      expect(current_path).to eq(account_path)
    end
  end
end
