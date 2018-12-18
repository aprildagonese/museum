class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit_instance)
    @exhibits << exhibit_instance
  end

  def recommend_exhibits(patron_instance)
    matching_interest_names = get_exhibit_names & patron_instance.interests

    @exhibits.select do |exhibit|
      matching_interest_names.include?(exhibit.name)
    end
  end

  def get_exhibit_names
    @exhibits.map do |exhibit|
      exhibit.name
    end
  end

  def admit(patron_instance)
    @patrons << patron_instance
  end

  def get_patrons_with_interest(exhibit)
    patrons_with_interest = []
    @patrons.each do |patron|
      if recommend_exhibits(patron).include?(exhibit)
        patrons_with_interest << patron
      end
    end
    return patrons_with_interest
  end

  def patrons_by_exhibit_interest
    patrons_by_interest_hash = {}
    @exhibits.each do |exhibit|
      patrons_by_interest_hash[exhibit] = get_patrons_with_interest(exhibit)
    end
    return patrons_by_interest_hash
  end

  def attendees(exhibit)
    

end
