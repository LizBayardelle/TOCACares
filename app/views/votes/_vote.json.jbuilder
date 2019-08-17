json.extract! vote, :id, :application_type, :application_id, :accept, :modify, :modification, :suggest_loan, :describe_loan, :deny, :denial_fund_overuse, :denial_not_qualify, :denial_unreasonable_request, :denial_not_involved_charity, :denial_other, :denial_other_description, :superseded, :references, :created_at, :updated_at
json.url vote_url(vote, format: :json)
