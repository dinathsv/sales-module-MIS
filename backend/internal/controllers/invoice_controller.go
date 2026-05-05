package controllers

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"sales-module/internal/models"
	"sales-module/internal/services"
)

type InvoiceController struct {
	service *services.InvoiceService
}

func NewInvoiceController(s *services.InvoiceService) *InvoiceController {
	return &InvoiceController{service: s}
}

func (ic *InvoiceController) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "20"))
	custID, _ := strconv.Atoi(c.Query("customer_id"))

	filter := models.InvoiceFilter{
		Status: c.Query("status"), CustomerID: custID,
		DateFrom: c.Query("date_from"), DateTo: c.Query("date_to"),
		Page: page, Limit: limit,
	}
	result, err := ic.service.ListInvoices(filter)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, result)
}

func (ic *InvoiceController) Get(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid invoice ID"})
		return
	}
	invoice, err := ic.service.GetInvoice(id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, invoice)
}

func (ic *InvoiceController) Generate(c *gin.Context) {
	saleID, err := strconv.Atoi(c.Param("saleId"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid sale ID"})
		return
	}
	invoice, err := ic.service.GenerateInvoice(saleID)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, invoice)
}
