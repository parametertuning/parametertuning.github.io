import subprocess
import tempfile

import fastapi
import fastapi.responses
from pydantic import BaseModel

app = fastapi.FastAPI()


class PostData(BaseModel):
    content: str


@app.post("/post")
def post(item: PostData):
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
  <title>Twitter2</title>
  <style>
  textarea {
    width: 100%;
    height: 30vh;
  }
  button {
    float: right;
    margin: 0.1rem;
  }
  </style>
</head>
<body>
  <div class="paper sm-8 margin-large" id="app">
    <div class="form-group">
      <textarea placeholder="Write Here!" v-model="content" :disabled="loading"></textarea>
      <button v-on:click="post" :disabled="loading">Post</button>
    </div>
    <div v-show="loading"><i class="fas fa-spinner fa-spin"></i> 少女投稿中</div>
    <div>{{stdout}}</div>
    <div>{{stderr}}</div>
  </div>
  <script>
    var app = new Vue({
      el: "#app",
      data: {
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
          fetch(`http://${location.host}/post`, {
            method: "POST",
            body: JSON.stringify({"content": this.content}),
          }).then(response => response.json())
          .then(msg => {
            this.loading = false;
            this.content = "";
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
