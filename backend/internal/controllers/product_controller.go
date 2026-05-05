package controllers

import (
	"net/http"
	"sales-module/internal/services"

	"github.com/gin-gonic/gin"
)

type ProductController struct {
	service *services.ProductService
}

func NewProductController(service *services.ProductService) *ProductController {
	return &ProductController{service: service}
}

func (pc *ProductController) List(c *gin.Context) {
	products, err := pc.service.List()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, products)
}
