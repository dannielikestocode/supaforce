public without sharing class StringBuilder {
    private final List<String> STRING_VALUES {get;set;}
    private final String DEFAULT_JOIN_VALUE = '';

    public StringBuilder() {
        this.STRING_VALUES = new List<String>();
    }

    public StringBuilder addValue(String value) {
        this.STRING_VALUES.add(value);
        return this;
    }

    public StringBuilder addValues(List<String> values) {
        this.STRING_VALUES.addAll(values);
        return this;
    }

    public StringBuilder addValues(Set<String> values) {
        this.STRING_VALUES.addAll(values);
        return this;
    }

    public override String toString() {
        return String.join(this.STRING_VALUES, this.DEFAULT_JOIN_VALUE);
    }

    public String toString(String joinValue) {
        if (String.isBlank(joinValue)) {
            joinValue = this.DEFAULT_JOIN_VALUE;
        }
        return String.join(this.STRING_VALUES, joinValue);
    }
}