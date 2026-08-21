const mongoose = require("mongoose");

const organizationSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true
    },

    status: {
      type: String,
      enum: ["active", "archived"],
      default: "active"
    },

    description: {
      type: String
    }
  },
  {
    timestamps: true
  }
);



const Organization = mongoose.model("Organization", organizationSchema);

module.exports = Organization;