import React from 'react'

function SendMessage() {
  const msg = React.useRef(null);
  const API_URL = process.env.REACT_APP_API_URL;
  const BACKEND_SECRET_KEY = process.env.REACT_APP_BACKEND_SECRET_KEY;
  const btn = React.useRef(null);

  const handleSubmit = e => {
    e.preventDefault();
    btn.current.setAttribute("disabled", "disabled");

    fetch(e.target.action, {
      method: e.target.method,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Secret-Header': BACKEND_SECRET_KEY,
      },
      body: JSON.stringify({
        message: msg.current.value,
      })
    }).then(result => {
        if (result.ok) {
          return result.text();
        } else {
          throw new Error(`Http error: ${result.status}`);
        }
      })
      .then(data => {
        console.log(data);
        alert("Good job! Your message should appear on Slack channel #aws-starter-kit-training-completion and in the browser console");
      })
      .catch(err => {
        console.log(err);
        alert("Something is bad :( Look at the browser console");
      });
  }


  return (
    <form
      id="post_form"
      action={ "https://" + API_URL + "/send-notification"}
      method="POST"
      onSubmit={handleSubmit}>
      <h2>Send message</h2>
      <label>
        <span className="text">Message: </span>
        <input type="text" name="message" ref={msg} />
      </label>
      <br />
      <br />
      <div className="align-right">
        <button ref={btn}>Submit</button>
      </div>
    </form>
  )
}

export default SendMessage;
