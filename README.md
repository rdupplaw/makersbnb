# makersbnb

## Specification

A web application that allows users to list spaces they have available, and to hire spaces for the night.

### Headline specifications

- Any signed-up user can list a new space.
- Users can list multiple spaces.
- Users should be able to name their space, provide a short description of the space, and a price per night.
- Users should be able to offer a range of dates where their space is available.
- Any signed-up user can request to hire any space for one night, and this should be approved by the user that owns that space.
- Nights for which a space has already been booked should not be available for users to book that space.
- Until a user has confirmed a booking request, that space can still be booked for that night.

### Nice-to-haves

- Users should receive an email whenever one of the following happens:
  - They sign up
  - They create a space
  - They update a space
  - A user requests to book their space
  - They confirm a request
  - They request to book a space
  - Their request to book a space is confirmed
  - Their request to book a space is denied
- Users should receive a text message to a provided number whenever one of the following happens:
  - A user requests to book their space
  - Their request to book a space is confirmed
  - Their request to book a space is denied
- A ‘chat’ functionality once a space has been booked, allowing users whose space-booking request has been confirmed to chat with the user that owns that space
- Basic payment implementation though Stripe.

## User stories

```
As a user,
So I can browse spaces,
I want to see a list of spaces.

As a user,
So I can list and request spaces as me,
I want to register.

As a lister,
So I can make my spaces available,
I want to add listings.

As a user,
So I can re-check my spaces and requests,
I want to log in.

As a user,
So no-one else can use my account on my machine,
I want to log out.

As a requester,
So I can book accomodation,
I want to request a space on a certain date.

As a lister,
So I can let the requester know their booking is confirmed,
I want to confirm a request.

As a lister,
So I can tell the requester that I deny their booking,
I want to deny a request.

As a requester,
So that I can't book an unavailable space,
I shouldn't be able to book a space which already has a confirmed booking for that day.

As a lister,
So I can show when my listing is available,
I want to select a start and end date for availability.
```
