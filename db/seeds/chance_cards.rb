Card.create!(card_name: 'Advance to "Go"', card_text: 'Collect $200', card_type: 'chance', method_name: "advance_to_go", default_quantity: 1)
Card.create!(card_name: 'Advance to Illinois Ave.', card_text: 'If you pass Go, collect $200', card_type: 'chance', method_name: "advance_to_illinois_ave", default_quantity: 1)
Card.create!(card_name: 'Advance to St. Charles Place', card_text: 'If you pass Go, collect $200.', card_type: 'chance', method_name: "advance_to_st_charles_place", default_quantity: 1)
Card.create!(card_name: 'Advance token to nearest Utility', card_text: 'If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total 10 times the amount thrown.', card_type: 'chance', method_name: "nearest_utility", default_quantity: 1)
Card.create!(card_name: 'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled.' , card_text: 'If Railroad is unowned, you may buy it from the Bank.', card_type: 'chance', method_name: "nearest_railroad", default_quantity: 2)
Card.create!(card_name: 'Bank pays you dividend of $50.', card_text: 'Collect $50', card_type: 'chance', method_name: "collect_fifty", default_quantity: 1)
Card.create!(card_name: 'Get out of Jail Free.', card_text: 'This card may be kept until needed, or traded/sold.', card_type: 'chance', method_name: "get_out_of_jail", default_quantity: 1)
Card.create!(card_name: 'Go Back Three Spaces.', card_text: 'Go Backwards Three Spaces', card_type: 'chance', method_name: "go_back_three", default_quantity: 1)
Card.create!(card_name: 'Go to Jail.', card_text: 'Go directly to Jail. Do not pass Go, do not collect $200.', card_type: 'chance', method_name: "go_to_jail", default_quantity: 1)
Card.create!(card_name: 'Make general repairs on all your property:', card_text: 'For each house pay $25, For each hotel $100.', card_type: 'chance', method_name: "repairs", default_quantity: 1)
Card.create!(card_name: 'Pay poor tax of $15', card_text: 'Pay $15 to Bank', card_type: 'chance', method_name: "pay_fifteen", default_quantity: 1)
Card.create!(card_name: 'Take a trip to Reading Railroad.', card_text: 'Advance token to Reading Railroad and If you pass Go, collect $200.', card_type: 'chance', method_name: "advance_to_r_r", default_quantity: 1)
Card.create!(card_name: 'Take a walk on the Boardwalk.', card_text: 'Advance token to Boardwalk.', card_type: 'chance', method_name: "advance_to_boardwalk", default_quantity: 1)
Card.create!(card_name: 'You have been elected Chairman of the Board.', card_text: 'Pay each player $50.', card_type: 'chance', method_name: "pay_fifty_to_all", default_quantity: 1)
Card.create!(card_name: 'Your building loan matures.', card_text: 'Collect $150', card_type: 'chance', method_name: "collect_onehunfifty", default_quantity: 1)
Card.create!(card_name: 'You have won a crossword competition.', card_text: 'Collect $100', card_type: 'chance', method_name: "collect_onehun", default_quantity: 1)
# Card.create!(card_name: 'Super Good Card.', card_text: 'Add 4 Super Good Spaces to Monoparty', card_type: 'chance', method_name: "super_good", default_quantity: 1)
# Card.create!(card_name: 'Super Bad Card.', card_text: 'Add 4 Super Bad Spaces to Monoparty', card_type: 'chance', method_name: "super_bad", default_quantity: 1)
