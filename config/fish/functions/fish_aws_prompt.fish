function fish_aws_prompt --description "Prompt function for AWS"
    if not command -sq aws
        return 1
    end

    if not command -sq aws
        return 1
    end

    if test -n "$AWS_DEFAULT_PROFILE"
        set -g aws_profile "$AWS_DEFAULT_PROFILE"
    else if test -n "$AWS_PROFILE"
        set -g aws_profile "$AWS_PROFILE"
    end
    if test -n "$aws_profile"
        echo -n -s (set_color bryellow) "[$aws_profile]" (set_color normal)
    end
end
