import hashlib
import os
import subprocess
import tempfile

import fastapi
import fastapi.responses
from pydantic import BaseModel

app = fastapi.FastAPI()
password = os.environ["PASSWORD"]


class PostData(BaseModel):
    content: str
    passphrase: str
    salt: str


@app.post("/post")
def post(item: PostData):
    if hashlib.md5(f"{password}{item.salt}".encode()).hexdigest() != item.passphrase:
        return {"status": "Err", "err": "Auth Error"}
    try:
        with tempfile.NamedTemporaryFile('wt') as f:
            f.write(item.content)
            f.seek(0)
            subprocess.run(f"git pull origin master".split(' '))
            subprocess.run(f"bash ./_scripts/post.sh {f.name}".split(' '))
            subprocess.run(f"make git".split(' '))
            return {"status": "OK"}
    except Exception as err:
        return {"status": "Err", "err": str(err)}


@app.get("/", response_class=fastapi.responses.HTMLResponse)
def read_root():
    return """
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="X-UA-Compatible" content="ie=edge">
  <link rel="stylesheet" href="https://unpkg.com/papercss@1.7.0/dist/paper.min.css">
  <script defer src="https://use.fontawesome.com/releases/v5.0.6/js/all.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/vue"></script>
  <script src="https://cdn.jsdelivr.net/npm/js-md5@0.7.3/src/md5.min.js"></script>
  <title>Twitter2</title>
  <style>
  div#app {
    padding: 3rem;
  }
  textarea {
    width: 100%;
    height: 30vh;
  }
  </style>
</head>
<body>
  <div id="app">
    <div class="form-group">
      <textarea placeholder="Write Here!" v-model="content" :disabled="loading"></textarea>
    </div>
    <div class="row">
      <div class="col col-10">
        <div class="form-group">
          <input type="password" v-model="auth" placeholder="auth">
        </div>
      </div>
      <div class="col col-2">
        <div class="form-group">
          <button v-on:click="post" :disabled="loading">Post</button>
        </div>
      </div>
    </div>
    <div v-show="loading"><i class="fas fa-spinner fa-spin"></i> 少女投稿中</div>
    <div class="text-primary">{{stdout}}</div>
    <div class="text-danger">{{stderr}}</div>
  </div>
  <script>
    var app = new Vue({
      el: "#app",
      data: {
        auth: "",
        content: "",
        stdout: "",
        stderr: "",
        loading: false,
      },
      methods: {
        post() {
          this.content = this.content.trim();
          if (this.content === "") {
            this.stderr = "Empty Content";
            return;
          }
          this.loading = true;
          this.stdout = "";
          this.stderr = "";

          var now = new Date();
          var salt = `${now.getMonth()}${Math.random()}${now.getDate()}`;
          var passphrase = md5(`${this.auth}${salt}`);

          fetch(`http://${location.host}/post`, {
            method: "POST",
            body: JSON.stringify({
                content: this.content,
                passphrase: passphrase,
                salt: salt,
            }),
          }).then(response => response.json())
          .then(msg => {
            if (msg.status == "OK") {
              this.content = "";
            }
            this.loading = false;
            this.stdout = msg;
            this.stderr = "";
          }).catch(msg => {
            this.loading = false;
            this.stderr = msg;
          });
        }
      },
    });
  </script>
</body>
</html>
     """
