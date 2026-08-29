const Task = require("../models/tasks.models");

// CREATE Task
const createTask = async (req, res) => {
  try {
    const task = await Task.create(req.body);

    res.status(201).json(task);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// GET All Tasks with Pagination
const getTasks = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const skip = (page - 1) * limit;

      const sortBy = req.query.sortBy || "createdAt";
    
    const sortOrder = req.query.sortOrder || "asc";

if (sortOrder !== "asc" && sortOrder !== "desc") {
  return res.status(400).json({
    message: "sortOrder must be either 'asc' or 'desc'"
  });
}

const sortDirection = sortOrder === "asc" ? 1 : -1;


    const total = await Task.countDocuments();

    const tasks = await Task.find()
      .sort({ [sortBy]: sortDirection })
      .skip(skip)
      .limit(limit);

    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      data: tasks,
      total,
      page,
      totalPages
    });
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

// GET Task By ID
const getTaskById = async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        message: "Task not found"
      });
    }

    res.status(200).json(task);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

// UPDATE Task
const updateTask = async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    if (!task) {
      return res.status(404).json({
        message: "Task not found"
      });
    }

    res.status(200).json(task);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// DELETE Task
const deleteTask = async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);

    if (!task) {
      return res.status(404).json({
        message: "Task not found"
      });
    }

    res.status(204).send();
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

module.exports = {
  createTask,
  getTasks,
  getTaskById,
  updateTask,
  deleteTask
};