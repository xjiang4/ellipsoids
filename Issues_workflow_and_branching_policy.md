Here and below we use a term "ticket" as a synonym of any type of issue including tasks, enhancements, bug reports etc created in the google issue tracker.

# Issue workflow and branching/merging policy #

  1. A ticket is created by a project owner and assigned to a developer with the status "New"
  1. Once developer starts working on an issue he/she
    1. changes the status to "Started".
    1. creates a branch using the following name patter **issue\_33\_bgates** or **issue\_33\_bill\_gates**. **DO NOT USE YOUR LOGINS, USE REAL NAMES**. So **issue\_16\_klivenn** is not ok, one should use **issue\_16\_dkovalev**
    1. starts making the changes withi his/her branch. Every commit message should have the following format
```
Issue #
BugFix: <description>
BugFix: <description>
Enhancement: <description>
Enhancement: <description>
```
  1. Once the source code is written, the latest changes from trunk are integrated into the branch a developer should run ALL unit tests by calling
```
elltool.test.run_tests()
```
> > When and if ALL tests pass (not just the newly written tests but ALL of them) a developer changes a ticket status to "ReadyForReview". This review request is assigned to a person who created the original issue. If the reviewer concludes that the task is ready then the reviewer notifies the developer that the task is ready for reintegration to trunk. The notification is done via changing the status to "ReadyForReintegration".
  1. When a developer is cleared for reintegration he/she strictly follows the **REINTEGRATION** algorithm
    1. Update you branch.
    1. Commit your changes.
    1. Merge trunk into your branch.
    1. Commit the result of the merge.
    1. Checkout latest trunk into a separate folder (or update an existing working copy of the trunk).
    1. Reintegrate to trunk FROM your branch. If there are conflicts -  resolve them carefully.
    1. Run all the tests on trunk without committing anything.
    1. If all tests pass - commit to trunk, if not - go to investigate, fix and go to step 1.
    1. Delete your branch.
    1. Monitor the automatic tests activity by subscribing to the automatic tests notification group (see the title page of the project). If the automatic tests pass after your commit - change the status of the ticket to "Reintegrated", if not - investigate, create the branch again, fix the problem and send a ticket to review ("ReadyForReview" status