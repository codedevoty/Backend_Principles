const Organization = require("../models/organizations.models");

// CREATE Organization
const createOrganization = async (req, res) => {
  try {
    const organization = await Organization.create(req.body);

    res.status(201).json(organization);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// GET All Organizations with Pagination
const getOrganizations = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const sortBy = req.query.sortBy || "createdAt";
    
    const sortOrder = req.query.sortOrder || "asc";
    

if (sortOrder !== "asc" && sortOrder !== "desc") {
  return res.status(400).json({
    message: "sortOrder must be either 'asc' or 'desc'"
  });
}     

     const status = req.query.status;
   // Validate status
    // if (status && !["active", "archived"].includes(status)) {
    //   return res.status(400).json({
    //     message: "status must be either 'active' or 'archived'"
    //   });
    // }

const sortDirection = sortOrder === "asc" ? 1 : -1;
        
    
  // Filter
    const filter = {};

    if (status) {
      filter.status = status;
    }


    const skip = (page - 1) * limit;

    const total = await Organization.countDocuments();

    const organizations = await Organization.find(filter) // add filter here
      .sort({ [sortBy]: sortDirection })
      .skip(skip)
      .limit(limit);

    const totalPages = Math.ceil(total / limit);

    res.status(200).json({
      data: organizations,
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

// GET Organization By ID
const getOrganizationById = async (req, res) => {
  try {
    const organization = await Organization.findById(req.params.id);

    if (!organization) {
      return res.status(404).json({
        message: "Organization not found"
      });
    }

    res.status(200).json(organization);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

// UPDATE Organization
const updateOrganization = async (req, res) => {
  try {
    const organization = await Organization.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    if (!organization) {
      return res.status(404).json({
        message: "Organization not found"
      });
    }

    res.status(200).json(organization);
  } catch (error) {
    res.status(400).json({
      message: error.message
    });
  }
};

// DELETE Organization
const deleteOrganization = async (req, res) => {
  try {
    const organization = await Organization.findByIdAndDelete(
      req.params.id
    );

    if (!organization) {
      return res.status(404).json({
        message: "Organization not found"
      });
    }

    res.status(204).send();
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};


// Archive an Organization
const archiveOrganization = async (req, res) => {
  try {
    const organization = await Organization.findByIdAndUpdate(
      req.params.id,
      {
        status: "archived"
      },
      {
        new: true,
        runValidators: true
      }
    );

    if (!organization) {
      return res.status(404).json({
        message: "Organization not found"
      });
    }

    res.status(200).json(organization);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
};

module.exports = {
  createOrganization,
  getOrganizations,
  getOrganizationById,
  updateOrganization,
  deleteOrganization,
  archiveOrganization
};