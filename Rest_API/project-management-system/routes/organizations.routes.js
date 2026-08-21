const express = require("express");

const {
  createOrganization,
  getOrganizations,
  getOrganizationById,
  updateOrganization,
  deleteOrganization,
  archiveOrganization
} = require("../controllers/organizations.controller");

const router = express.Router();

router.post("/", createOrganization);

router.get("/", getOrganizations);

router.get("/:id", getOrganizationById);

router.patch("/:id", updateOrganization);

router.delete("/:id", deleteOrganization);

router.post("/:id/archive", archiveOrganization);

module.exports = router;