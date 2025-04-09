# Example workflow
# Declare WDL version 1.0 if working in Terra
version 1.0
workflow myWorkflow {
    input {
    File test_file
  }
}

task myTask {
    command <<<
        echo "hello world"
        echo ~{test_file}
    >>>
    output {
        String out = read_string(stdout())
    }
}
