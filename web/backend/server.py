from starlette.applications import Starlette
from starlette.responses import JSONResponse
import uvicorn
import aiohttp
import base64
from fastai.vision import *

defaults.device = torch.device('cpu')
#path = Path('/home/mreishus/rpg-ann')
path = Path('.')
learner = load_learner(path)

app = Starlette(debug=True)

async def get_bytes(url):
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.read()

@app.route("/classify-url", methods=["GET"])
async def classify_url(request):
    bytes2 = await get_bytes(request.query_params["url"])
    return predict_image_from_bytes(bytes2)

@app.route("/upload", methods=["POST"])
async def upload(request):
    data = await request.form()
    s = data["file"]
    [mime, data_string] = s.split(",", 2)
    #print(s)
    b = base64.b64decode(data_string)
    return predict_image_from_bytes(b)
    #return predict_image_from_string(s)

#def predict_image_from_string(s):
#    b = base64.b64decode(s)
#    img = open_image(BytesIO(b))
#    _, _, losses = learn.predict(img)
#    return JSONResponse({
#        "predictions": sorted(
#            zip(learner.data.classes, map(float, losses)),
#            key=lambda p: p[1],
#            reverse=True
#        )
#    })

def predict_image_from_bytes(b):
    img = open_image(BytesIO(b))
    _, _, losses = learner.predict(img)
    return JSONResponse({
        "predictions": sorted(
            zip(learner.data.classes, map(float, losses)),
            key=lambda p: p[1],
            reverse=True
        )
    })

@app.route('/')
async def homepage(request):
    return JSONResponse({'hello': 'world'})

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8000)
