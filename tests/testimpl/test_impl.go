package common

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/nexient-llc/lcaf-component-terratest-common/types"
	"github.com/stretchr/testify/assert"
)

func TestPrivateEndpointComplete(t *testing.T, ctx types.TestContext) {

	t.Run("TestPrivateEndpoint", func(t *testing.T) {
		privateEndpointId := terraform.Output(t, ctx.TerratestTerraformOptions, "private_endpoint_id")
		assert.NotEmpty(t, privateEndpointId, "Private endpoint ID must not be empty")
	})
}
