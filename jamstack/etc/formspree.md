<style>
@import url(https://fonts.googleapis.com/css?family=Open+Sans);

body{
margin: 0;
font-family: 'Open Sans';
font-size: 1.5em;}

labels,
input{
  display: block;
  margin: 1em;
}
input[type="text"] {
  padding: 1em;
}
input[type="email"]{
  padding: 1em;
}
input[type="message"]{
  padding: 1em;
}
</style>


<form action="https://formspree.io/mpzyozye" method="POST">
  <label for="name">Your name: </label>
  <input type="text" name="name" required="required" placeholder="Name"><br>
  <label for="email">Your email: </label>
  <input type="email" name="_replyto" required="required" placeholder="email"><br>
  <label for="message">Your message:</label><br>
  <textarea rows="4" name="message" id="message" required="required" class="form-control" placeholder="Your message here."></textarea>
  <input type="hidden" name="_next" value="/html/thanks.html" />

  <br>

  <input type="submit" value="Send" name="submit" class="btn-default">

  <!-- Hidden Fields -->
  <input type="text" name="_gotcha" style="display:none" />
  <input type="hidden" name="_next" value="http://www.ewu.edu"
</form>