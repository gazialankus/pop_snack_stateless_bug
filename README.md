# pop_snack_stateless_bug

Turns out this is [not really a bug](#The-Fix)

A Flutter project demonstrating the snack after pop bug in stateless widgets.

I have three StatelessWidget instances that I travel through with Navigator.push(). The last one has a TextField. Focusing on that textfield before doing the Navigator.pop() apparently makes the second page's scaffold key's element null. 

Here's what to do to reproduce this bug:
1. Press the button twice to get to the third page, which contains a TextField and a Button.
2. Tap that text field to focus it and hit that button.
3. Surprise! Only then _scaffoldKey.currentState becomes null and we get `04:38:57.385 25 info flutter.tools NoSuchMethodError: The getter 'className' was called on null.`

If you don't focus the TextField, this won't happen. 

Using `Builder` instead of `GlobalKey` to get to the `Scaffold` did not help. 

## The Fix

Turns out the problem was storing the `GlobalKey` inside a `StatelessWidget`. The StatelessWidget gets recreated and we get a new GlobalKey instance. Later we try to use the old instance to access the snack bar, which fails. 

Flutter does not enforce not having any fields in `StatelessWidget`s. You have to enforce it yourself, otherwise you create weird bugs like this.

I just checked and there is no linter rule for this. I wish linter could warn if we use a GlobalKey field in a StatelessWidget.  