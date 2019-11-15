# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ApplicationStatus.create!([
  { id: 1, status: "Application Started" },
  { id: 2, status: "Application in Progress" },
  { id: 3, status: "Submitted to Committee" },
  { id: 4, status: "Returned with Modifications" },
  { id: 5, status: "Decision Reached" },
  { id: 6, status: "Withdrawn" }
])

FinalDecision.create!([
  { id: 1, status: "Not Decided" },
  { id: 2, status: "Rejected" },
  { id: 3, status: "Modifications Requested" },
  { id: 4, status: "Approved with Modifications" },
  { id: 5, status: "Approved" },
  { id: 6, status: "Withdrawn" }
])

FundingStatus.create!([
  { id: 1, status: "Not Applicable" },
  { id: 2, status: "Funding in Progress" },
  { id: 3, status: "Funding Completed" }
])
