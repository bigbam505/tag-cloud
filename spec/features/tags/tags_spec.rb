require 'spec_helper'

feature 'Tags' do
  scenario 'can only be edited from logged in users' do
    navigate_to_tags_index
    verify_user_does_not_have_access
  end

  scenario 'should be able to be created' do
    login_user_via_github
    navigate_to_tags_index
    add_a_tag
    verify_tag_was_added
  end

  scenario 'can be shown in a list' do
    login_user_via_github
    tags = create_tags_with_mapped_values(3)
    navigate_to_tags_index
    verify_tags_are_listed_in_table(tags)
  end

  scenario 'can be seen individually with a list of values' do
    login_user_via_github
    tag = create_tag_with_mapped_value
    navigate_to_tag(tag)
    verify_tag_page(tag)
  end
end

def create_tags_with_mapped_values(tag_count = 2, mapped_value_count = 2)
  tags = create_list(:tag, tag_count)
  tags.each_with_index do |tag, i|
    create_list(:mapped_value, mapped_value_count + i, tag: tags[0])
  end

  tags
end

def create_tag_with_mapped_value(mapped_value_count = 2)
  tag = create(:tag)
  create_list(:mapped_value, mapped_value_count, tag: tag)

  tag
end

def navigate_to_tags_index
    visit root_url
    click_link 'Tags'
end

def navigate_to_tag(tag)
  navigate_to_tags_index
  click_link tag.name
end

def verify_tag_page(tag)
  page.should have_selector('h2', text: tag.name)
  page.should have_selector('p', text: tag.description)
  within 'table.table' do
    tag.mapped_values.each do |mapped_value|
      page.should have_content mapped_value.value
    end
  end
end

def verify_tags_are_listed_in_table(tags)
  within 'table.table' do
    tags.each do |tag|
      page.find('tr', text: tag.name).should have_content tag.mapped_values.count
    end
  end
end

def add_a_tag
  click_link 'Add Tag'
  fill_in 'Tag Name', with: 'first-tag'
  fill_in 'Description', with: 'Here is my long description describing the tag'
  click_button 'Add Tag'
end

def verify_tag_was_added
  page.should have_content 'Added tag first-tag'
end
