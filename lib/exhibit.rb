class Exhibit
  attr_reader :name, :cost, :attendees

  def initialize(name, cost)
    @name = name
    @cost = cost
    @attendees = []
  end

  def admit_to_exhibit(patron)
  end

  def in_budget?(patron)
    if patron.spending_money >= @cost
      true
    end
  end

  def is_interested?(patron)
    if patron.interests.include?(@name)
      true
    end
  end

end
