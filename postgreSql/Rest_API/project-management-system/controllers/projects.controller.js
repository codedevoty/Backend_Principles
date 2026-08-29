const Project = require("../models/projects.models");

// CREATE Project
const createProject = async (req, res) => {
  try {
    const project = await Project.create(req.body);

    res.status(201).json(project);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// GET All Projects with Pagination
const getProjects = async (req, res) => {
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


    const total = await Project.countDocuments();

    const projects = await Project.find()
      .sort({ [sortBy]: sortDirection })
      .skip(skip)
      .limit(limit);

    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      data: projects,
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

// GET Project By ID
const getProjectById = async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({
        message: "Project not found"
      });
    }

    res.status(200).json(project);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

// UPDATE Project
const updateProject = async (req, res) => {
  try {
    const project = await Project.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    if (!project) {
      return res.status(404).json({
        message: "Project not found"
      });
    }

    res.status(200).json(project);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// DELETE Project
const deleteProject = async (req, res) => {
  try {
    const project = await Project.findByIdAndDelete(req.params.id);

    if (!project) {
      return res.status(404).json({
        message: "Project not found"
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
  createProject,
  getProjects,
  getProjectById,
  updateProject,
  deleteProject
};