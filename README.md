Bloom & Wild test
===============

Hello! And welcome to the Bloom & Wild coding exercise.

We recommend you spend around 3-4 hours over this exercise, but how much time you take is up to you. Read through the brief below for details of what to do and what we're looking for.

When you've finished please email sharon@bloomandwild.com and srik@bloomandwild.com and we'll arrange a time to discuss your work on the exercise. If you have any questions, just drop us an email.

Test brief

In this test you'll be building a simple app to enable placement of an order for a bouquet, and deploying it via CI to heroku.

We'll be looking for things like:
* A clean and simple solution
* Done in a standard way
* solid use of tests

Tasks

* Add the ability to upgrade shipping (£2.50 per order) to "Special Delivery"
* Create a new model called "Delivery" containing:

  - Bouquet
  - User name
  - Delivery date
  - Reference to the order that created it
* Add a rake task called "Shipping". When this task runs it should take a date as an argument and create a Delivery object
  for all Order objects going out that day that have status "billed". A delivery contains:

  - Bouquet
  - User name
  - Delivery date

  It should set the status of Order to "complete" when it is done.
* Add a new attribute to Delivery "three_month_bundle" that, if true, will have a delivery every month from the Order's
  delivery_on date for 3 months (Price increase is `Bouquet.price * 3` but with a 10% discount on bouquet 2 and 3)
* Update the Shipping task to make sure it produces deliveries for these bundles, orders should remain in "billed" until
  all three deliveries have been created.
* Add seeds with example bouquets
* Update the home page order form to enable you to place an order of a bouquet
* integrate codeship and deploy via CI to heroku
* Discussion: How might you improve the architecture of the code? Specifically think about what might happen if the application were
  to die mid way through processing an order and what will happen as complexity increases

Bonus:

* Extend the shipping task so that, on bundles after the first delivery, it should cycle through the bouquets (in ASC by
  ID order). If there are 3 bouquets and bouquet ID 2 is chosen for the 3 month bundle then the 2nd delivery (a month
  after Order.delivery_on) will have bouquet ID 3 and the 3rd delivery (2 months after Order.delivery on) should have
  bouquet ID 1.
* Discussion: What considerations would there be if we were to actually take payment? How might this be implemented?


# Bloom & Wild
### Notes on the challenge
- Is there any reason why the delivery objects cannot be created when the order is created instead of via the rake task. The rake task could then be scrapped altogether as it's no longer necessary.
- I wasn't sure how the Delivery object was supposed to know about the three_month_bundle attribute and what it should be set to as this is only created once the task has been run. For this reason I added this attribute to the Order object. Ideally I would prefer to not to have this attribute and favour an order type attribute that could then be used to instantiate a class at runtime to handle how this type should be handled. This would make it easier to implement 4 month bundle, christmas bundle etc.
- The Order object has an assign cost method, this currently only needs to support single and three_month_bundle delivery costs. If this were to change and we had more types then it may be worth looking at using decorator pattern which would extend the original Order model to account for the differences between the types. Additionally exchanging the the three_month_bundle attribute for an order_type attribute may be better as you could then delegate to a specific class to process the different types of delivery and logic surrounding them. The adapter or factory pattern are potential candidates for this kind of delegation of responsibility (As also mentioned above).
- The Order object current has three states, if the transitions were to grow and increase in complexity a state machine may make the the code easier to read as well as easier to understand and plan workflows surrounding orders and deliveries.

### Improvements
- For three month bundle it should ensure that the future delivery dates are not on a Sunday as you do not delivery on Sundays.
- Have the home page show a list of bouquets and allow the user to select a specific bouquet and for the order form to be aware of this.
- Handling of the failed orders, I don't know the scenario of when an order would fail but if it were to then it should be handled in the correct manner and Bloom & Wild should be aware of this. I favour service objects over callbacks for this. In the service object (create_order.rb) it should handle the failed order object by either notifying you by email or adding it to a report that is handled in house.
- The order form should provide better error messages to the user, 'There was a problem' simply isn't good enough. In addition to better errors the date picker should not allow users to select dates that are not valid.
- Create the delivery objects as the order is created, As you are looking to grow and move internationally, having a rake task that selects all orders in a specific state to then create delivery objects (plus whatever computation) at a set time may cause issues in the future when you have no time of day whereby the traffic to your site is low.

