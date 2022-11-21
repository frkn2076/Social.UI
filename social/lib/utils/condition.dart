enum Condition { none, success, fail }

extension BoolExtension on bool {
  Condition conditionParser() => this ? Condition.success : Condition.fail;
}
