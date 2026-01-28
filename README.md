# Pet Care Discovery & Activity Tracking Platform

## 1. Overview

The **Pet Care Discovery & Activity Tracking Platform** is a mobile application prototype designed to improve trust and transparency between pet owners and caregivers. The application enables pet owners to discover nearby caregivers and receive structured, time-stamped updates about pet care activities through explicit user actions.

The project is intentionally built as a **software-only prototype**, focusing on reliable workflows, clear data modeling, and transparent interactions without relying on hardware sensors, wearables, or paid third-party services.

---

## 2. Problem Statement

In urban environments, pet owners often depend on informal or unverified arrangements when hiring pet walkers or caregivers. Once a pet is handed over, owners lack clear visibility into:

* Who is providing care
* When the care activity started and ended
* What actions were performed during the session

This absence of structured processes leads to uncertainty, reduced trust, and poor accountability. Existing solutions often attempt to solve this using continuous GPS tracking or hardware devices, which introduce privacy, cost, and reliability concerns.

---

## 3. Solution Approach

This project approaches the problem by prioritizing **structured transparency over surveillance**.

Instead of continuous tracking, the platform relies on:

* Explicit caregiver actions (start/end activity)
* Immutable, time-stamped records
* Location context at key moments
* Clear booking and activity workflows

Trust is built incrementally through consistent behavior, visible history, and accountability rather than one-time verification or intrusive monitoring.

---

## 4. Core Objectives

* Enable trusted, location-based discovery of caregivers
* Provide clear visibility into pet care activities
* Establish accountability through traceable records
* Deliver a reliable MVP within a controlled scope
* Follow modern software development best practices

---

## 5. System Architecture

### 5.1 Frontend

* Built using **Flutter** for cross-platform mobile support
* State-driven UI architecture
* Google Maps SDK for spatial visualization
* Designed with clarity and minimal user friction

### 5.2 Backend

* **Firebase Authentication** for identity management
* **Cloud Firestore** for real-time, scalable data storage
* **Firebase Cloud Functions** for event-driven backend logic

---

## 6. Functional Features

### 6.1 Authentication & User Roles

* Secure user authentication via Firebase Auth
* Explicit role separation:

  * Pet Owner
  * Caregiver
* Role-based access control for all critical actions

---

### 6.2 Pet Profile Management

* Create and manage pet profiles
* Store basic pet information
* Maintain care instructions and notes

---

### 6.3 Caregiver Discovery

* Map-based discovery of caregivers
* Proximity-based filtering
* Caregiver profile view with experience and service details

---

### 6.4 Booking Workflow

* Structured booking lifecycle:

  * Pending
  * Accepted
  * Completed
* All interactions occur within the platform
* Prevents informal or untraceable engagements

---

### 6.5 Activity Logging (Core Feature)

* Caregivers explicitly start and end an activity
* On activity start:

  * Timestamp is recorded
  * Current location is captured
* On activity end:

  * End timestamp and location are recorded
  * Optional notes and photos can be added

Each activity record is immutable once completed and is tied to:

* A specific caregiver
* A specific pet
* A specific booking

---

### 6.6 Owner Visibility

Pet owners can view:

* Activity start and end times
* Total duration
* Start and end locations displayed on a map
* Notes or photos shared by the caregiver

This creates a clear, auditable timeline of events.

---

### 6.7 Notifications

* Push notifications for:

  * Booking acceptance
  * Activity start
  * Activity completion
* Implemented using Cloud Functions reacting to database changes

---

## 7. Data Model Overview

High-level Firestore collections:

* `users`
* `pets`
* `caregivers`
* `bookings`
* `activities`

The data model emphasizes:

* Clear ownership relationships
* Immutable activity logs
* Predictable state transitions

---

## 8. Development Practices Followed

* Clear separation of concerns (UI, logic, data)
* Predictable and explicit state transitions
* Defensive validation in backend functions
* Consistent naming and schema conventions
* Early scope definition to avoid feature creep
* Emphasis on reliability over feature volume

---

## 9. Scope Decisions and Trade-offs

To maintain stability and ensure timely delivery, the following features were intentionally excluded from the MVP:

* Real-time GPS tracking
* Background location monitoring
* Hardware sensors or wearables
  
  These decisions reduced complexity while improving privacy and system reliability.

---

## 10. Future Enhancements

Potential improvements identified for future iterations:

* Location consistency checks
* Reputation scoring over time
* Admin moderation dashboard
* Offline activity logging and sync
* Calendar-based scheduling
* Secure payment integration

---

## 11. UX & Design Process

* User flows and screen designs created in **Figma**
* Focus on intuitive navigation and low cognitive load
* Explicit action buttons for critical operations
* Timeline-based visualization for activities

---

## 12. Key Learnings

* Trust is built through transparency and repetition, not promises
* Explicit user actions are more reliable than automation
* Designing for human error improves system resilience
* Controlled scope is essential for delivering quality software

---

## 13. Intended Use

This project is intended for:

* Portfolio demonstration
* Technical interviews
* Learning and experimentation

It represents a realistic prototype rather than a production-scale commercial system.

---

## 14. Conclusion

The Pet Care Discovery & Activity Tracking Platform demonstrates how thoughtful system design, controlled scope, and transparent workflows can address trust and visibility challenges without relying on complex infrastructure. The project emphasizes engineering judgment, reliability, and user-centric design, aligning with modern software development practices.
