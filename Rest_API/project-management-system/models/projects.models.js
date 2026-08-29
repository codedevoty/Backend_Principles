const mongoose = require("mongoose");

const projectSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true
    },

    organizationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Organization",
      required: true
    },

    status: {
      type: String,
      enum: ["planned", "in_progress", "completed"],
      default: "planned"
    },

    description: {
      type: String
    }
  },
  {
    timestamps: true
  }
);

const Project = mongoose.model("Project", projectSchema);

module.exports = Project;