# Salesforce Senior Coding Challenge

We appreciate you taking the time to participate and submit a coding challenge! 🥳

In the next step we would like you to implement a simple Invocable Apex Action to be used by your Admin colleagues for a Flow. They need to do HTTP callouts to a NPS Service, whenever an Order got fulfilled. Below you will find a list of tasks and optional bonus points required for completing the challenge.

**🚀 This is a template repo, just use the green button to create your own copy and get started!**

### Invocable:

* accepts the Order Record Ids as Input Parameter
* queries the required records to get the Bill To E-Mail Address (`Contact.Email`) and OrderNumber (`Order.OrderNumber`)
* sends the data to the NPS API
* add a basic Flow, that executes your Action whenever an Order Status is changed to `Fulfilled`

### The Mock NPS API:

* Hosted at https://salesforce-coding-challenge.herokuapp.com
* ✨[API Documentation](https://thermondo.github.io/salesforce-coding-challenge/)
* 🔐 uses HTTP Basic Auth, username: `tmondo`, password: `Noy84LRpYvMZuETB`

### ⚠️ Must Haves:

* [x] use `sfdx` and `git`, commit all code and metadata needed (so we can test with a scratch org)
* [x] write good meaningful unit tests
* [x] properly separate concerns
* [x] make a list of limitations/possible problems

### ✨ Bonus Points:

* [] layer your Code (use [apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common) if you like)
* [x] use Inversion of Control to write true unit tests and not integration tests
* [x] make sure customers don't get duplicate emails
* [x] think of error handling and return them to the Flow for the Admins to handle

### What if I don't finish?

Finishing these tasks should take about 2-3 hours, but we are all about **'quality > speed'**, so it's better to deliver a clean MVP and leave some TODOs open.

Try to produce something that is at least minimally functional. Part of the exercise is to see what you prioritize first when you have a limited amount of time. For any unfinished tasks, please do add `TODO` comments to your code with a short explanation. You will be given an opportunity later to go into more detail and explain how you would go about finishing those tasks.


## ✅ My Implementation

### 🔧 Technologies Used

- Salesforce DX (SFDX)
- Apex Common (fflib)
- ApexMocks for unit tests
- Named Credential for secure external callouts
- Flow for post-fulfillment automation


## ⚠️ Limitations / Design Considerations

- `Survey_Sent__c` (Checkbox) is required on the `Order` object to prevent duplicate survey sends. This is **set to true inside the Apex logic** after a successful NPS submission.
- A Named Credential named `NPS` must be configured with HTTP Basic Auth. This is used to securely call the external API without exposing credentials in code.
- The Invocable Apex method returns structured output (`success`, `message`, `orderId`) to the Flow. Exceptions are caught and converted into meaningful flow output to avoid Flow crashes.
- The mock NPS API accepts a **maximum of 30 orders per request**. This is handled inside the `NpsHttpSender` class via manual batching.
- The current architecture avoids using `@future` or `@queueable` since the Flow-invoked Apex method **supports callouts directly**. Using `@future` would complicate error handling and break the return structure expected by the Flow.
- Failed callouts are not retried or logged for later. In production, you could enhance this with:
  - Retry queueing (e.g. Platform Events, Custom Object)
  - Monitoring/reporting of failed NPS requests
- The system assumes `BillToContact.Email` and `OrderNumber` are available and populated. Orders missing either will be skipped.
- The `NpsSurveyService.send()` method returns a single `Boolean` to indicate the overall success of the batch. This means if **any order in the batch fails**, the entire batch is marked as failed and no individual success state is tracked. For production environments, it would be better to return a `Map<Id, Boolean>` or similar structure to support per-order status, partial successes, and retry logic.

