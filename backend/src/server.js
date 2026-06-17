const express = require("express");
const cors = require("cors");

const wordsRoutes = require("./routes/words.routes");

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
  res.send("LingoBreeze API Running");
});

app.use("/words", wordsRoutes);

const PORT = 3001;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});