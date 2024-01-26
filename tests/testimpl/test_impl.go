package common

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/nexient-llc/lcaf-component-terratest-common/types"
	"github.com/stretchr/testify/assert"
)

func TestPrivateEndpointComplete(t *testing.T, ctx types.TestContext) {
	t.Run("TestAlwaysSucceeds", func(t *testing.T) {
		assert.Equal(t, "foo", "foo", "Should always be the same!")
		assert.NotEqual(t, "foo", "bar", "Should never be the same!")
	})

	// When cloning the skeleton to a new module, you will need to change the below test
	// to meet your needs and add any new tests that apply to your situation.
	t.Run("TestPrivateEndpoint", func(t *testing.T) {
		privateEndpointId := terraform.Output(t, ctx.TerratestTerraformOptions, "private_endpoint_id")

		assert.NotEmpty(t, privateEndpointId, "Private endpoint ID must not be empty")
	})
}
