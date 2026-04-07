from fastapi import FastAPI

app = FastAPI()
about_var = "Message"

@app.get("/")
def check():
    return {"data": "Healthy"}

@app.get("/about")
def check():
    return {"data": f"{about_var} from {open("/api_key.txt", "r").read()}"}
