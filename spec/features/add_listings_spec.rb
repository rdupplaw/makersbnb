# frozen_string_literal: true

feature 'Add listings' do
  scenario 'A user can add a listing' do
    visit '/listings'
    click_button('List a Space')

    expect(current_path).to eq '/listings/new'
    expect(page).to have_content('List a Space')

    fill_in('Name', with: 'Test_1')
    fill_in('Description', with: 'Nice space, allows cats')
    fill_in('Price per night', with: '100.00')
    fill_in('Available from (DD/MM/YY)', with: '12/12/21')
    fill_in('Available to (DD/MM/YY)', with: '13/12/21')
    click_button('List my Space')

    expect(current_path).to eq '/listings'
    expect(page).to have_content('Test_1')
    expect(page).to have_content('Nice space, allows cats')
    expect(page).to have_content('$100.00')
  end
end
