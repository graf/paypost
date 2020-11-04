# README

## Solution

This is simple payment gateway API with basic functionality of handling transactions.
- API for processing of authorize/charge/refund/reversal transactions
- UI for manage merchants.

Transaction Logic
- Each payment request/attempt is stored even if it failed. If payment processing fails it stored and marked with :error. 
Ideally it must be done in a separate model, e.g. PaymentRequest, but it is out of scope of the task.
- Authorize can have only one full charge. Second charge or partial charge is not allowed.
- Charge can have multiple refunds. Total refunds must not exceed total charge amount.

Admin UI
- Create/Update/Destroy merchants
- Inspect merchant transactions 

Merchant UI
- Inspect own transactions 

![Merchant UI](https://api.monosnap.com/file/download?id=ZI4IorwFcI5fv3j8YyY8i0VvMkoCtc)

### Implementation
Business logic is decoupled from Rails application and placed in `app/concepts` folder. It is build with:    
- **Use Cases** are used to handle all user-related operations. It implements **Interactor** pattern (not gem). 
- **Form Objects** are used to validate user's input. 
- **Presenters (View Models)** are used to expose and shape data for presentation layer.
- **Service Object** are used to process business logic of payments.
- **Policies** are used to handle permissions

**STI** used for Transactions classes

Frontend is implemented using **bootstrap**, **webpacker**

Scheduled (**cron**) jobs is implemented using clockwork gem  

States are implemented with simple enums. It is enough for the purpose of tasks, so State Machine was not used. 

### Tests
- Business logic has near 100% unit test coverage.
- Rails application has lower coverage and can be improved. 
- RSpec is used for testing.
- Capybara is used for feature testing. 
- SimpleCove is used for calculating test coverage. Run full test suites (`rspec`) and open `coverage/index.html`.

### Caveats
- Main focus was on the application core, rather than proper setting up environment and dependencies.
- Commits organized in "features" i.e. one commit per feature. 
It is done for easier review in one go, since the application is quite big. 
Each feature-commit has description which approximately reflects atomic smaller commits in real project.  
- One dev environment is tested. The source code is as production-ready as possible, though application might need 
few more steps to properly run in production environment.
- [TODO.md](TODO.md) has the list of some remaining steps to do

## How to Use

### Prerequisites
Application was developed and tested with following environment
- PostgreSQL 13.0
- ruby 2.7.1
- nodejs 14.14.0
- yarn 1.22.5

### Running the application locally
`docker-compose.yml` configured to run PostgreSQL and expose 55555 port to localhost.

```bash
bundle install
docker-compose up
bundle exec rake db:create db:migrate db:seed
bundle exec rake import_merchants\['db/seeds/merchants.csv'\]
PORT=3000 foreman start
```

### As Admin
Go to http://localhost:3000/admins/merchants

Use credentials `admin@paypost.com / 123456` from `seeds/admins.rb`

### As Merchant
Go to http://localhost:3000/merchants/transactions

Use credentials `merchant1@paypost.com / 12345678` from `seeds/merchants.csv`
 
### API
1. Get token
```bash
curl \
  -X POST http://localhost:3000/api/v1/auth/sign_in \
  -D - \
  -d "email=merchant1@paypost.com" \
  -d "password=12345678"
```
Take headers for next API requests 
```
access-token
client
uid
```

2. Submit Payment

Make sure `uuid` is unique for each request. Each `uuid` can be used once and only once.  
```bash
curl \
  -X POST http://localhost:3000/api/v1/payments \
  -H 'client: 14PmhzFUXujhA4QrOabeVw' \
  -H 'access-token: rvmCH6gdTG4LmAqHUfYLBA' \
  -H 'uid: merchant1@paypost.com' \
  -F "type=authorize" \
  -F "uuid=3" \
  -F "amount=50" \
  -F "customer_email=test@test.com"
```
- For charge/reverse add `-F "authorize=:authorizeId"`, where `:authorizeId` is `uuid` to existing authorize
- For refund add `-F "charge=:chargeId"`, where `:chargeId` is `uuid` to existing charge
