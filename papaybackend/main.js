const express = require("express");
const bodyParser = require("body-parser");
const { nanoid } = require('nanoid'); 
const { MongoClient, ServerApiVersion } = require("mongodb");

// Replace with your actual URI
const uri = "DBURI";

// Create Mongo Client
const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  },
});

const app = express();
const PORT = 3000;

// Middleware to parse JSON
app.use(bodyParser.json());

// Connect to MongoDB before starting the server
client.connect().then(() => {
  console.log("Connected to MongoDB");

  const db = client.db("Cluster0"); // replace with your DB name if different
  const repairRequestCollection = db.collection("repairRequest");
  const messagesCollection = db.collection("messages");

  const createMessagesCollection = async (trackingId)=>{
    try{
      const response = await messagesCollection.insertOne({trackingId: trackingId,admin: false,client: false,messages: []});
      return 200;
    }catch(e){
      return 400;
    }
  }

  app.post("/repairRequest", async (req, res) => {
    try {
      const data = req.body;
      const trackingId=nanoid(10);
      data.trackingId = trackingId;
      const result = await repairRequestCollection.insertOne(data);
      const messageColRes = await createMessagesCollection(trackingId);
      res.status(200).json({trackingId: trackingId ,message: "Data inserted successfully!" });
    } catch (err) {
      res.status(500).json({ error: "Internal server error" });
    }
  });

  app.get("/getRequests",async (req,res)=>{
    const phone = req.query.phone

    if (!phone) {
        return res.status(400).json({ error: "Phone query parameter is required" });
      }
    try{
        const data = await repairRequestCollection.find({ phone: phone}).toArray();
        if(data.length===0){
            res.status(200).json({success: true,message: "No Request found"})
        }
        res.status(200).json({data: data});
    }catch(e){
        res.status(500).json({ error: "Internal server error" });
    }
  })

  app.get("/getallRequests",async (req,res)=>{
    try{
        const data = await repairRequestCollection.find().toArray();
        if(data.length===0){
            res.status(200).json({success: true,message: "No Request found"})
        }
        res.status(200).json({data: data});
    }catch(e){
        res.status(500).json({ error: "Internal server error" });
    }
  })


  app.post("/sendMessage", async (req, res) => {
    console.log("sending message")
  const trackingId = req.body.trackingId;
  const author = req.body.author;
  const message = req.body.message;
  const timestamp = req.body.timestamp;

  try {
    const response = await messagesCollection.updateOne(
      { trackingId: trackingId },
      {
        $set: author==="admin"?{admin: true}:{client: true},
        $push: {
          messages: {  
            author: author,
            message: message,
            timestamp: timestamp
          }
        }
      }
    );
    res.status(200).json({ message: "Message added successfully", updated: response.modifiedCount });
  } catch (e) {
    res.status(400).json({ error: "Failed to add message" });
  }
});

app.get("/getMessages",async(req,res)=>{
  const trackingId = req.query.trackingId;
  try{
    const response = await messagesCollection.findOne({trackingId: trackingId});
    res.status(200).json(response);
  }catch(e){
    res.status(400).json("Error");
  }
})

app.post("/removeRequest", async (req, res) => {
  console.log("remove request")
  const trackingId = req.body.trackingId;
  console.log(trackingId);
  try {
    const response = await repairRequestCollection.deleteOne({ trackingId: trackingId });
    const msgres = await messagesCollection.deleteOne({ trackingId: trackingId });
    return res.status(200).json(["Deleted Successfully"]);
  } catch (e) {
    console.error(e);
    return res.status(400).json(["Unable to delete"]);
  }
});

app.post("/changeStatus", async(req,res)=>{
  console.log("change status")
  const status = req.body.status;
  const trackingId = req.body.trackingId
  try{
    const response = await repairRequestCollection.updateOne({trackingId: trackingId},{
      $set:{status: status}
    });
    res.status(200).json(true)
  }catch(e){
    res.status(400).json(true)
  }
})


  app.listen(PORT,'0.0.0.0', () => {
    console.log(`Listening at http://localhost:${PORT}/`);
  });
}).catch(err => {
  console.error("Failed to connect to MongoDB:", err);
});
