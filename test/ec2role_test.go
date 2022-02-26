package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestTerraformEc2rolemodule(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: "../iamrole",
		Vars: map[string]interface{}{
			"region":     "us-east-1",
			"access_key": "AKIASRC4BHTKD6EAU32Y",
			"secret_key": "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",
		},
	})

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	//output := "Hello World"
	//assert.Equal(t, "Hello World", output)
	output := terraform.Output(t, terraformOptions, "name")

	//output1 := terraform.Output(t, terraformOptions, "iamroleid")
	assert.Equal(t, "sree_iam_role", output)
}

// Create test folder and then create test file testvpcmod_test.go
//PS D:\workspacevpc\test> go mod init test

//Then write function
//PS D:\workspacevpc\test> go get github.com/gruntwork-io/terratest/modules/terraform
//PS D:\workspacevpc\test> go get github.com/stretchr/testify/assert
//PS D:\workspacevpc\test> go test -v testvpcmod_test.go
