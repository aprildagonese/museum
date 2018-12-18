require 'minitest/autorun'
require 'minitest/pride'
require './lib/patron'
require './lib/exhibit'
require './lib/museum'
require 'pry'

class MuseumTest < MiniTest::Test

  def test_it_exists
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_instance_of Museum, dmns
  end

  def test_it_has_attributes
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal "Denver Museum of Nature and Science", dmns.name
  end

  def test_it_starts_with_no_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.exhibits
  end

  def test_it_adds_and_remembers_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal [gems_and_minerals, dead_sea_scrolls, imax], dmns.exhibits
  end

  def test_it_gets_exhibit_names
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    assert_equal ["Gems and Minerals", "Dead Sea Scrolls", "IMAX"], dmns.get_exhibit_names
  end

  def test_it_recommends_exhibits
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")

    assert_equal [gems_and_minerals, dead_sea_scrolls], dmns.recommend_exhibits(bob)
    assert_equal [imax], dmns.recommend_exhibits(sally)
  end

  def test_it_starts_with_no_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")

    assert_equal [], dmns.patrons
  end

  def test_it_admits_and_remembers_patrons
    dmns = Museum.new("Denver Museum of Nature and Science")
    bob = Patron.new("Bob", 20)
    sally = Patron.new("Sally", 20)

    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal [bob, sally], dmns.patrons
  end

  def test_it_gets_patrons_with_shared_interest
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    sally.add_interest("Dead Sea Scrolls")
    dmns.admit(bob)
    dmns.admit(sally)

    assert_equal [bob, sally], dmns.get_patrons_with_interest(dead_sea_scrolls)
    assert_equal [sally], dmns.get_patrons_with_interest(imax)
  end

  def test_it_groups_patrons_by_exhibit_interests
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    bob = Patron.new("Bob", 20)
    bob.add_interest("Dead Sea Scrolls")
    bob.add_interest("Gems and Minerals")
    sally = Patron.new("Sally", 20)
    sally.add_interest("IMAX")
    dmns.admit(bob)
    dmns.admit(sally)

    expected = { gems_and_minerals => [bob], dead_sea_scrolls => [bob], imax => [sally] }

    assert_equal expected, dmns.patrons_by_exhibit_interest
  end

  def test_it_knows_when_patron_can_afford_exhibit
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    sally = Patron.new("Sally", 20)

    assert_equal true, dead_sea_scrolls.in_budget?(sally)
  end

  def test_it_knows_when_patron_is_interested
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    sally = Patron.new("Sally", 20)
    sally.add_interest("Dead Sea Scrolls")

    assert_equal true, dead_sea_scrolls.is_interested?(sally)
    assert_equal false, gems_and_minerals.is_interested?(sally)
  end


  def test_it_stores_exhibit_attendees
    skip
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal [tj], dmns.attendees(dead_sea_scrolls)
  end

  def test_it_limits_attendance_by_spending_money
    skip
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal [], dmns.attendees(imax)
  end

  def test_it_limits_attendance_by_interests
    skip
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal [], dmns.attendees(gems_and_minerals)
  end

  def test_it_collects_revenue
    skip
    dmns = Museum.new("Denver Museum of Nature and Science")
    gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    imax = Exhibit.new("IMAX", 15)
    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)
    tj = Patron.new("TJ", 7)
    tj.add_interest("Dead Sea Scrolls")
    dmns.admit(tj)

    assert_equal 10, dmns.revenue
  end

end
