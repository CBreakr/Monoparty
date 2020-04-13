# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#card_name, card_text, type (all strings)

chance1 = Card.create(card_name: 'Advance to "Go"', card_text: 'Collect $200', card_type: 'Chance')
chance2 = Card.create(card_name: 'Advance to Illinois Ave.', card_text: 'If you pass Go, collect $200', card_type: 'Chance')
chance3 = Card.create(card_name: 'Advance to St. Charles Place', card_text: 'If you pass Go, collect $200.', card_type: 'Chance')
chance4 = Card.create(card_name: 'Advance token to nearest Utility', card_text: 'If unowned, you may buy it from the Bank. If owned, throw dice and pay owner a total 10 times the amount thrown.', card_type: 'Chance')
chance5 = Card.create(card_name: 'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled.' , card_text: 'If Railroad is unowned, you may buy it from the Bank.', card_type: 'Chance')
chance6 = Card.create(card_name: 'Advance token to the nearest Railroad and pay owner twice the rental to which he/she is otherwise entitled.' , card_text: 'If Railroad is unowned, you may buy it from the Bank.', card_type: 'Chance')
#two of these 
chance7 = Card.create(card_name: 'Bank pays you dividend of $50.', card_text: 'Collect $50', card_type: 'Chance')
chance8 = Card.create(card_name: 'Get out of Jail Free.', card_text: 'This card may be kept until needed, or traded/sold.', card_type: 'Chance')
chance9 = Card.create(card_name: 'Go Back Three Spaces.', card_text: 'Go Backwards Three Spaces', card_type: 'Chance')
chance10 = Card.create(card_name: 'Go to Jail.', card_text: 'Go directly to Jail. Do not pass Go, do not collect $200.', card_type: 'Chance')
chance11 = Card.create(card_name: 'Make general repairs on all your property:', card_text: 'For each house pay $25, For each hotel $100.', card_type: 'Chance')
chance12 = Card.create(card_name: 'Pay poor tax of $15', card_text: 'Pay $15 to Bank', card_type: 'Chance')
chance13 = Card.create(card_name: 'Take a trip to Reading Railroad.', card_text: 'Advance token to Reading Railroad and If you pass Go, collect $200.', card_type: 'Chance')
chance14 = Card.create(card_name: 'Take a walk on the Boardwalk.', card_text: 'Advance token to Boardwalk.', card_type: 'Chance')
chance15 = Card.create(card_name: 'You have been elected Chairman of the Board.', card_text: 'Pay each player $50.', card_type: 'Chance')
chance16 = Card.create(card_name: 'Your building loan matures.', card_text: 'Collect $150', card_type: 'Chance')
chance17 = Card.create(card_name: 'You have won a crossword competition.', card_text: 'Collect $100', card_type: 'Chance')

cc1 = Card.create(card_name: 'Advance to "Go"', card_text: 'Collect $200', card_type: 'Community Chest')
cc2 = Card.create(card_name: 'Bank error in your favor.', card_text: 'Collect $200', card_type: 'Community Chest')
cc3 = Card.create(card_name: "Doctor's fees.", card_text: 'Pay $50', card_type: 'Community Chest')
cc4 = Card.create(card_name: 'From sale of stock you get $50.', card_text: 'Collect $50', card_type: 'Community Chest')
cc5 = Card.create(card_name: 'Get Out of Jail Free', card_text: 'This card may be kept until needed or sold/traded.', card_type: 'Community Chest')
cc6 = Card.create(card_name: 'Go to Jail.', card_text: 'Go directly to jail. Do not pass Go, Do not collect $200.', card_type: 'Community Chest')
cc7 = Card.create(card_name: 'Grand Opera Night', card_text: 'Collect $50 from every player for opening night seats.', card_type: 'Community Chest')
cc8 = Card.create(card_name: 'Holiday Fund matures.', card_text: 'Receive $100.', card_type: 'Community Chest')
cc9 = Card.create(card_name: 'Income tax refund.', card_text: 'Collect $20', card_type: 'Community Chest')
cc10 = Card.create(card_name: 'It is your birthday.', card_text: 'Collect $10 from every player.', card_type: 'Community Chest')
cc11 = Card.create(card_name: 'Life insurance matures', card_text: 'collect $100', card_type: 'Community Chest')
cc12 = Card.create(card_name: 'Hospital Fees', card_text: 'Pay $50', card_type: 'Community Chest')
cc13 = Card.create(card_name: 'School fees.', card_text: 'Pay $50', card_type: 'Community Chest')
cc14 = Card.create(card_name: 'Receive $25 consultancy fee.', card_text: 'Collect $25', card_type: 'Community Chest')
cc15 = Card.create(card_name: 'You are assessed for street repairs:', card_text: 'Pay $40 per house and $115 per hotel you own.', card_type: 'Community Chest')
cc16 = Card.create(card_name: 'You have won second prize in a beauty contest.', card_text: 'Collect $10', card_type: 'Community Chest')
cc17 = Card.create(card_name: 'You inherit $100.', card_text: 'Collect $100', card_type: 'Community Chest')




