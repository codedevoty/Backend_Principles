const express = require("express");
const dotenv = require("dotenv");
const connectDB = require("./config/db");

dotenv.config();

const app = express();

app.use(express.json());

connectDB();

app.get("/", (req, res) => {
  res.send("Project Management System API is running");
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});

const organizationRoutes = require("./routes/organizations.routes");
const projectRoutes = require("./routes/projects.routes");
const taskRoutes = require("./routes/tasks.routes");

app.use(express.json());

app.use("/organizations", organizationRoutes);
app.use("/projects", projectRoutes);
app.use("/tasks", taskRoutes);