From original rails template:

Organizations have users.  Users can be one of two roles: admin for the group or a user.  The admin has the ability to remove users from the group and see the stats of the user.

A user should be able to sign up.
A user should be able to join a group.

An admin should be able to create a group.


New functionality - Have you ever...bingo?
############


#Relationships
Users-Organizations = many to many
Organization-Templates = 1 to many
Template-Squares = 1 to many
Templates-Users = many to many (through cards)
User-Cards = 1 to many
Card-Circles = 1 to many
User-Circles = 1 to many (through card)

#NOTE:
To make sure that the user always plays the card he got, the circles are created at the same time the card is created.

#Tables
##Templates
- size (integer - 4 would indicate a 4x4 bingo card. 5 is the default.  Must be between 4 x 7)
- belong to an organization
- name
- rating (enum) - easy, medium, hard
- public? - boolean (default to false)
- token (for public sharing)

'accept_nested_attributes_for' squares

##Squares
- position_x (1 to size)
- position_y (1 to size)
- picture
- question
- belong to a template
- free_space?
Unique index: [position_x, position_y, template_id]

##Cards
- belong to a template
- belong to a user
- has_many circles
- token (for url for sharing)
- is_public? (default to false)
- num_bingos

method: has_bingo? (called after every change and saved, because otherwise it has to be computed all the time)

##Circles
- belong to a card
- belong_to a user and a template through card
- belongs_to a square (saving the position)
- response
- part_of_bingo? (default to false); go ahead and store this, as it otherwise it will have to be computed all the time
- copies of original value at time of creation (in case admin changes after user starts playing)
 - value
 - picture
 - position_x
 - position_y

Unique index: [card_id, square_id]

Or methods
- marked? (default to false)

# Controller rules
##Templates
Only an admin of an organization can create, edit, update, or delete their template.  
All users should be able to see a template (because that's where they will pick it) or the index of templates.
(The organization page should show all users the index of templates.  In addition, admins should see a list of the people in their organization.

The show page should show the template.  In addition, admins should be able to see the statuses of players on that template.)

####What if an admin deletes or edits a template that a user has already played?
An admin can edit or delete a template but instances of the template (cards) in play will not be affected
Let the admin know at the time of editing/deleting that they will not be deleting all instances

```ruby
  resources :organizations do
    resources :templates, except: :index
  end
```

1. The organization token should be only for sign ups
2. The organization page (by id) is public
3. Templates are public on case-by-case basis on the organizations page

admin-only
new --> organizations/:organization_id/templates/new
create 
edit --> organizations/:organization_id/templates/:id
update
destroy -->


show --> 
- all users (without a login)
  - denied if private; if public, template, rating, number of cards
- a member should see
  - private templates, rating, number of cards
- an admin should also see:
  - private templates
  - all cards and the statuses of players of that template

index of templates not available, but would be visible to admins and members on the organization page

index --> (on organizations show page)
- all users (without a login)
 - public templates, rating, number of cards
- a member should see
 - private templates, rating, number of cards
- an admin should also see:
 - all people belonging to the organization

##Squares
No controllers or views for squares.  All updating of those values are done from nested attributes of templates

##Cards
Only a user can create, edit, update, or destroy their own card.
Admins can view cards for their organization but cannot edit, update, or destroy.
Public cards can be seen without a login.

```ruby
  resources :cards, except: :new
  get cards/:token/share => 'cards#share'
```
create --> (params[:card][:template_id]) (only member)
edit --> (only owner)
update --> (only owner)
destroy --> (only owner) (also destroys the circles)
show --> (owner and admin)
index -->
- all users (without a login) should see
 - nothing.  This is for a user's cards
- user should see & admin should see
 - all of their own personal cards, private and public, with a link to update/destroy
  - If admins want to see cards of their organizations' members, they should go see the organization's show page 
share --> 
- all users (without a login) if public

##Circles

No views for circles, but controller is available to handle updates (json should also be available)
Only a user can update their circle.

```ruby
  resources :circles, only: [:update]
```
~~new, create, edit, destroy, show, index~~

Since the circles are copies of the squares and are destroyed/created at the same time as the cards, you don't need those parts of a circle.  You also don't need to show or index the circles, since you will see them on the card.