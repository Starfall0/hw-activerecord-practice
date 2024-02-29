# frozen_string_literal: true

require 'sqlite3'
require 'active_record'
require 'byebug'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'customers.sqlite3')
# Show queries in the console.
# Comment this line to turn off seeing the raw SQL queries.
ActiveRecord::Base.logger = Logger.new($stdout)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  #  NOTE: Every one of these can be solved entirely by ActiveRecord calls.
  #  You should NOT need to call Ruby library functions for sorting, filtering, etc.

  def self.any_candice
    # YOUR CODE HERE to return all customer(s) whose first name is Candice
    # probably something like:  Customer.where(....)
    Customer.where(first: 'Candice')
  end

  def self.with_valid_email
    # YOUR CODE HERE to return only customers with valid email addresses (containing '@')
    Customer.where.not(email: nil).where.not(email: '').where('email LIKE ?', '%@%')
  end

  # etc. - see README.md for more details
  def self.with_dot_org_email
    # return customers with email addresses ending in '.org'
    Customer.where('email LIKE ?', '%.org')
  end

  def self.with_invalid_email
    # return customers with invalid email addresses
    Customer.where.not(email: [nil, '', ' ']).reject { |customer| customer.email.include?('@') }
  end

  def self.with_blank_email
    # return customers with blank email addresses
    Customer.where(email: [nil, '', ' '])
  end

  def self.born_before1980
    # return customers born before January 1, 1980
    Customer.where('birthdate < ?', Date.new(1980, 1, 1)) # (Date.new => year, month, day)
  end

  def self.with_valid_email_and_born_before1980
    # return customers with valid email addresses and born before 1980
    Customer.with_valid_email.born_before1980
  end

  def self.last_names_starting_with_b
    # return customers with last names starting with 'B' ordered by birthdate
    # select column 'last' that start with B
    Customer.where('last LIKE ?', 'B%').order(:birthdate)
  end

  def self.twenty_youngest
    # return the twenty youngest customers order by birthdate
    # desc: descending order
    # asc : ascending  order
    Customer.order(birthdate: :desc).limit(20)
  end

  def self.update_gussie_murray_birthdate
    # update Gussie Murray's birthdate to February 8, 2004
    Customer.find_by(first: 'Gussie', last: 'Murray').update(birthdate: Time.parse('2004-02-08')) # (Time.parse => 'YEAR-MONTH-DAY')
  end

  def self.change_all_invalid_emails_to_blank
    # change all invalid emails to blank
    Customer.where.not(email: [nil, '', ' ']).where.not('email LIKE ?', '%@%').update_all(email: '')
  end

  def self.delete_meggie_herman
    # delete the customer named 'Meggie Herman'
    Customer.find_by(first: 'Meggie', last: 'Herman').destroy
  end

  def self.delete_everyone_born_before1978
    # delete all customers born before December 31, 1977
    Customer.where('birthdate <= ?', Date.new(1977, 12, 31)).destroy_all
  end
end
