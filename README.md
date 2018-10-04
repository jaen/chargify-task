# chargify-task

## Description

Just your ye olde Railse applicatione for the Chargify recruitment task.

The usual stuff works:

  * `rake db:migrate` to migrate the database,
  * `rake db:seed` to seed the datbase (required for `SubscriptionLevel`s to exist)
  * `rails s` runs the app with Puma,
  * `rails c` opens a Pry console with the application environment,
  * `bundle exec guard` watches the tests,
  * `rails yard` builds documentation,
  * `rake charge_expired_subscriptions` to charge subscriptions that expire at the end of current day.

Also has some unusual stuff:

  * `logic/validators` is a directory of API parameters validations,
  * `logic/transactions` is a directory of API transactions, decoupled from persistence models,
  * `logic/operations` is a directory of domain operations.

The application needs the FakePay key specified as `FAKE_PAY_KEY` environment variable.

Tests need _both_ migrations and seeds (for `SubscriptionLevel`s).

## Example API calls

The API follows JavaScript field naming convention. A 2xx reply will contain data under the `data` key, a 4xx reply will contain errors under the `errors` key.

To create a new subscription for a new customer run the following `curl` in a bash-compatible shell (drop `jq` if you don't have it, but the API JSON output will not be pretty printed by default):

```bash
cat <<EOJSON | curl -v -X POST localhost:3000/subscriptions -H "Content-Type: application/json" -d @- | jq
{
   "subscription": {
      "shippingAddressDetails": {
         "name": "Herp Derp",
         "address": "Hurr Durr Street",
         "country": "PL",
         "zipCode": 12345
      },
      "subscriptionLevelId": 1
   },
   "payment": {
      "billingDetails": {
        "cardNumber": "4242424242424242",
        "securityCode": "123",
        "expirationMonth": 1,
        "expirationYear": 2024,
        "zipCode": "12345"
      }
   }
}
EOJSON
```

To create a new subscription for an existing customer specify `customerId` instead of `shippingAddressDetails`:

```bash
cat <<EOJSON | curl -v -X POST localhost:3000/subscriptions -H "Content-Type: application/json" -d @- | jq
{
   "subscription":{
      "customerId": 209,
      "subscriptionLevelId":1
   },
   "payment": {
      "billingDetails":{
        "cardNumber":"4242424242424242",
        "securityCode":"123",
        "expirationMonth":1,
        "expirationYear":2024,
        "zipCode":"12345"
      }
   }
}
EOJSON
```

To create a new subscription for card that was already charged, specify `cardDetailsId` instead of `billingDetails`:

```bash
cat <<EOJSON | curl -v -X POST localhost:3000/subscriptions -H "Content-Type: application/json" -d @- | jq
{
   "subscription":{
      "customerId": 209,
      "subscriptionLevelId":1
   },
   "payment": {
      "cardDetailsId": 1
   }
}
EOJSON
```
